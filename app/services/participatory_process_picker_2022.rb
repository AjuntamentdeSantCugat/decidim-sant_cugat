# frozen_string_literal: true

class ParticipatoryProcessPicker2022

  PROCESS_GROUP_ID = 3
  PROCESS_GROUP_URL = "/processes_groups/#{PROCESS_GROUP_ID}"

  attr_reader :current_user, :district_council

  MAPPING = {
    "CB1" => "/processes/nucliantic2022/f/545/budgets/10/projects",
    "CB2" => "/processes/centreest2022/f/544/budgets/9/projects",
    "CB3" => "/processes/centreoest2022/f/542/budgets/7/projects",
    "CB4" => "/processes/lafloresta2022/f/543/budgets/8/projects",
    "CB5" => "/processes/mirasol2022/f/546/budgets/11/projects",
    "CB6" => "/processes/lesplanes2022/f/547/",
    "CB7" => "/pages/quipotvotaralspressupostos"
  }

  def initialize(current_user)
    @current_user = current_user
    @district_council = authorization_metadata.dig("district_council")

    Rails.logger.info "[ParticipatoryProcessPicker2022] Authorizations: #{authorization_metadata}"
    Rails.logger.info "[ParticipatoryProcessPicker2022] District council: #{district_council}"
  end

  def process_url
    if district_council.blank?
      if current_user.nil?
        return host + PROCESS_GROUP_URL
      else
        if authorization_metadata.blank?
          redirect_url = host + "/parcicipatory_process_redirect"
          return host + "/authorizations/new?handler=census_authorization_handler&redirect_url=#{redirect_url}"
        else
          flash[:notice] = "No se ha encontrado el proceso en el que puedes votar"
          return host + PROCESS_GROUP_URL
        end
      end
    else
      return host + (MAPPING[district_council] || PROCESS_GROUP_URL)
    end
  end

  def component_id
    @component_id ||= begin
      slug = if district_council.blank?
               MAPPING.values.first.split("/")[1]
             else
               process_url.split("/")[1]
             end

      if process = process_group.participatory_processes.find_by(slug: slug)
        if component = process.components.where(manifest_name: "proposals").first
          component.id
        else
          raise "Component not found for process #{slug}"
        end
      else
        raise "Process not found with slug: #{slug}"
      end
    end
  end

  private

  def process_group
    @process_group ||= Decidim::ParticipatoryProcessGroup.find(PROCESS_GROUP_ID)
  end

  def host
    case Rails.env
    when "production"
      "https://decidim.santcugat.cat"
    when "staging"
      "https://decidim-sant-cugat.populate.tools"
    else
      "http://localhost:3000"
    end
  end

  def authorization_metadata
    return {} if current_user.nil?

    if current_user.extended_data.empty?
      decidim_authorization_metadata.presence || {}
    elsif authorizations = current_user.extended_data.dig("authorizations")
      if authorization = authorizations.find{ |a| a["name"] == "census_authorization_handler" }
        authorization.dig("metadata").presence || {}
      else
        {}
      end
    else
      {}
    end
  end

  def decidim_authorization_metadata
    return {} if current_user.nil?

    if authorization = Decidim::Authorization.where(decidim_user_id: current_user.id).first
      authorization.metadata
    else
      {}
    end
  end
end
