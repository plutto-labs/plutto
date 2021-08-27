class Api::BaseSerializer < ActiveModel::Serializer
  attributes :id

  def id
    object.identifier
  end

  [:customer, :organization, :plan_version].each do |model|
    define_method :"#{model}_id" do
      object.public_send(model).try(:identifier)
    end
  end
end
