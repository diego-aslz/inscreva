class XLargeStringInput < FormtasticBootstrap::Inputs::StringInput
  def input_html_options
    super.merge(:class => "input-xlarge")
  end
end
