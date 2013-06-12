class XxLargeStringInput < FormtasticBootstrap::Inputs::StringInput
  def input_html_options
    super.merge(:class => "input-xxlarge")
  end
end
