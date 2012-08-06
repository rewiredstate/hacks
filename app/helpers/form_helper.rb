module FormHelper
  def disable_if_persisted(resource, options)
    resource.persisted? ? options : { }
  end
end