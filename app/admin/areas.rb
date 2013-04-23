ActiveAdmin.register Area do
  filter :event
  filter :name
  filter :requirement

  controller do
    def new
      @area = Area.new(vacation: 0, special_vacation: 0)
      new!
    end
  end
end
