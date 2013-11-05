module ModalDialogHelper
  def modal_dialog(options={},&block)
    content_tag :div, {class: 'modal hide fade', tabindex: -1, role: 'dialog'}.merge(options), &block
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
    content_tag :button, 'X', {class: 'close', :'data-dismiss' => :modal, type: :button}.merge(options)
  end

  def modal_cancel(options={})
    content_tag :button, options.delete(:caption), {class: 'btn', :'data-dismiss' => :modal}.merge(options)
  end
end
