generate('resource widget name:string user_id:integer')
generate('resource derived_widget')

run('rake db:reset')
run('rake db:migrate')
run('rake db:test:prepare')
