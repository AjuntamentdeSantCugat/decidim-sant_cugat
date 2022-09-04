Decidim::Proposals::Proposal.find_each do |p|
  p.answer = nil if p.answer.blank?
  p.cost_report = nil if p.cost_report.blank?
  p.execution_period = nil if p.execution_period.blank?
  p.save!
end
