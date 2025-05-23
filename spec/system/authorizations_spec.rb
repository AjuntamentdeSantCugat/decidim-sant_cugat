# frozen_string_literal: true

require "rails_helper"

describe "Authorizations", type: :system, perform_enqueued: true, with_authorization_workflows: ["census_authorization_handler"] do
  let(:organization) do
    create(
      :organization,
      name: "Ajuntament",
      default_locale: :ca,
      available_locales: [:ca],
      available_authorizations: authorizations
    )
  end
  let(:authorizations) { ["census_authorization_handler"] }

  let(:response) do
    JSON.parse("{ \"res\": 1 }")
  end

  # Selects a birth date that will not cause errors in the form: January 12, 1979.
  def fill_in_authorization_form
    fill_in "authorization_handler_document_number", with: "12345678A"
    select "12", from: "authorization_handler_date_of_birth_3i"
    select "Gener", from: "authorization_handler_date_of_birth_2i"
    select "1979", from: "authorization_handler_date_of_birth_1i"
  end

  before do
    allow_any_instance_of(CensusAuthorizationHandler).to receive(:response).and_return(response)
    switch_to_host(organization.host)
  end

  context "user account" do
    let(:user) { create(:user, :confirmed, organization: organization) }

    before do
      login_as user, scope: :user
      visit decidim.root_path
    end

    it "allows the user to authorize against available authorizations" do
      within_user_menu do
        click_link "El meu compte"
      end

      click_link "Autoritzacions"
      click_link "El padró"

      fill_in_authorization_form
      click_button "Enviar"

      expect(page).to have_content("Se t'ha autoritzat correctament")

      visit decidim_verifications.authorizations_path

      within ".authorizations-list" do
        expect(page).to have_content("El padró")
        expect(page).not_to have_link("El padró")
      end
    end

    context "when the user has already been authorised" do
      let!(:authorization) do
        create(:authorization,
               name: CensusAuthorizationHandler.handler_name,
               user: user)
      end

      it "shows the authorization at their account" do
        visit decidim_verifications.authorizations_path

        within ".authorizations-list" do
          expect(page).to have_content("El padró")
          expect(page).to have_content(I18n.localize(authorization.granted_at, format: :long_with_particles, locale: :ca))
        end
      end
    end
  end
end
