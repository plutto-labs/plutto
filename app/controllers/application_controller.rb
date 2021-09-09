class ApplicationController < ActionController::Base
  include PowerTypes::Presentable

  private

  def rename_nested_object_params_for_nested_attributes(params, attribute)
    return params unless params[attribute]

    params["#{attribute}_attributes"] = params.delete attribute
    params.permit!
  end
end
