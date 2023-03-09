require "csv"

CSV.open("/app/storage/report.csv", "wb") do |csv|
  csv << ["process", "document_number"]
  (ParticipatoryProcessPicker2022::MAPPING.values.select{ |v| v.include?("processes")}).each do |url|
    slug = url.split("/")[2]
    process = Decidim::ParticipatoryProcess.find_by(slug: slug)
    component = process.components.where(manifest_name: "budgets").first
    puts slug
    budget = Decidim::Budgets::Budget.find_by decidim_component_id: component.id
    puts budget.id
    puts "============="
    #budget.orders.each do |order|
    #  user = order.user
    #  if authorization = Decidim::Authorization.find_by(decidim_user_id: user.id)
    #    csv << [slug, authorization.metadata["document_number"]]
    #  end
    #end
  end
end
