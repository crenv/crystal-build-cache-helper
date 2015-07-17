# -*- encoding: utf-8 -*-

task :setup do
  sh %[bundle install --path=vendor/bundle]
end

task :generate do
  sh %[bundle exec -- ruby generate-crystal-build-cache.rb > releases.json]
end

task :update do
  sh %[git clone git@github.com:pine613/crystal-build.git]

  cd 'crystal-build' do
    sh %[git checkout -b cache origin/cache]

    unless File.exists? 'releases.json'
      touch 'releases.json'
    end

    if `diff ../releases.json releases.json`.length > 0
      sh %[cp ../releases.json .]
      sh %[git config user.name "Snap CI"]
      sh %[git config push.default current]
      sh %[git add .]
      sh %[git commit -m "Update releases.json"]
      sh %[git push]
    end
  end
end
