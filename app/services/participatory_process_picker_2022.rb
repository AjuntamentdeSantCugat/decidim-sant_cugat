# frozen_string_literal: true

class ParticipatoryProcessPicker2022

  PROCESS_GROUP_URL = '/processes_groups/3'
  PROCESS_GROUP_ID = 3

  attr_reader :current_user

  MAPPING = {
    "CB1" => "/processes/nucliantic2022",
    "CB2" => "/processes/centreest2022",
    "CB3" => "/processes/centreoest2022",
    "CB4" => "/processes/lafloresta2022",
    "CB5" => "/processes/mirasol2022",
    "CB6" => "/processes/lesplanes2022",
    "CB7" => ""
  }

  def initialize(current_user)
    @current_user = current_user
    @distrinct_council = nil

    if current_user.nil? || current_user.extended_data.nil?
      Rails.logger.info "[ParticipatoryProcessPicker2022] User extended data not found"
      return
    end

    authorizations = current_user.extended_data.dig("authorizations")
    if authorizations
      if authorization = authorizations.find{ |a| a["name"] == "census_authorization_handler" }
        @district_council = authorization.dig("metadata", "district_council")
      end
    end
    Rails.logger.info "[ParticipatoryProcessPicker2022] Authorizations: #{authorizations}"
    Rails.logger.info "[ParticipatoryProcessPicker2022] District council: #{@district_council}"
  end

  def process_url
    if @district_council.nil?
      if current_user.nil?
        return host + PROCESS_GROUP_URL
      else
        authorizations = current_user.extended_data.dig("authorizations")
        if authorizations.empty?
          redirect_url = host + "/parcicipatory_process_redirect"
          redirect_to host + "/authorizations/new?handler=census_authorization_handler&redirect_url=#{redirect_url}"
        else
          flash[:notice] = "No se ha encontrado el proceso en el que puedes votar"
          return host + PROCESS_GROUP_URL
        end
      end
    else
      host + (MAPPING[@district_council] || PROCESS_GROUP_URL)
    end
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

  def component_id
    @component_id ||= begin
      slug = if @distrinct_council.nil?
               MAPPING.values.first.split("/").last.strip
             else
               process_url.split("/").last.strip
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
end
