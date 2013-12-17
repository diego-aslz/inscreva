module ModalDialogHelper
  def modal_dialog(options={},&block)
    content_tag :div, {class: 'modal fade', tabindex: -1, role: 'dialog'}.merge(options) do
      content_tag :div, class: 'modal-dialog' do
        content_tag :div, class: 'modal-content', &block
      end
    end
  end

  def modal_header(options={},&block)
    content_tag :div, {class: 'modal-header'}.merge(options), &block
  end

  def modal_body(options={},&block)
    content_tag :div, {class: 'modal-body'}.merge(options), &block
  end

  def modal_footer(options={},&block)
    content_tag :div, {class: 'modal-footer'}.merge(options), &block
  end

  def modal_close(options={})
    content_tag :button, '&times;'.html_safe, {class: 'close', type: :button,
      :'data-dismiss' => :modal, 'aria-hidden' => 'true'}.merge(options)
  end

  def modal_cancel(options={})
    content_tag :button, options.delete(:caption), {class: 'btn btn-default',
      :'data-dismiss' => :modal}.merge(options)
  end
end
