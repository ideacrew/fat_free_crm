FactoryBot.define do
  factory :index_case, class: "FatFreeCrm::IndexCase" do
    user
    assigned_to         { nil }
    access              { "Public" }
    source              { %w[campaign cold_call conference online referral self web word_of_mouth other].sample }
    background_info     { FFaker::Lorem.paragraph[0, 255] }
    updated_at          { FactoryBot.generate(:time) }
    created_at          { FactoryBot.generate(:time) }
    investigation_kind  { "simple"}
    projected_return_date { FactoryBot.generate(:time) }
  end
end
