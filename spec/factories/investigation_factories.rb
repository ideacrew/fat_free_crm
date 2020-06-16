FactoryBot.define do
  factory :investigation, class: "FatFreeCrm::Investigation" do
    user
    index_case
    assigned_to_id         { nil }
    conducted_at        { FactoryBot.generate(:time) }
    updated_at          { FactoryBot.generate(:time) }
    created_at          { FactoryBot.generate(:time) }
  end
end
