module Decidim
  class ParticipatoryProcessPickerController < DecidimController
    def redirect
      ppp = ::ParticipatoryProcessPicker2022.new(current_user)
      redirect_to ppp.process_url and return false
    end
  end
end
