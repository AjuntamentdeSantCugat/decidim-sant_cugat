# frozen_string_literal: true

class ParticipatoryProcessPicker2022

  PROCESS_GROUP_URL = '/processes_groups/3'
  PROCESS_GROUP_ID = 3

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
    @distrinct_council = nil

    return if current_user.nil?

    authorizations = current_user.extended_data["authorizations"]
    if authorizations
      if authorization = authorizations.find{ |a| a["name"] == "census_authorization_handler" }
        @district_council = authorization.dig("metadata", "district_council")
      end
    end
  end

  def process_url
    MAPPING[@distrinct_council || MAPPING.keys.first]
  end

  def component_id
    @component_id ||= begin
      slug = process_url.split("/").last.strip

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
