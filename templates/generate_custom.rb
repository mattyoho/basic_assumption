generate('resource widget name:string user_id:integer')
generate('resource derived_widget')
generate('resource sprocket name:string widget_id:integer')

inside('app/models') do
  inject_into_class('widget.rb',   'Widget') do
    "  has_many :sprockets\n"
  end
  inject_into_class('sprocket.rb', 'Sprocket') do
    "  belongs_to :widget\n"
  end
end

rake('db:reset')
rake('db:migrate')
rake('db:test:prepare')
