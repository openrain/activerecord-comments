# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{activerecord-comments}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["remi"]
  s.date = %q{2009-02-02}
  s.description = %q{Provides an easy to access database table/column comments from ActiveRecord}
  s.email = %q{remi@remitaylor.com}
  s.files = ["VERSION.yml", "README.markdown", "lib/activerecord-comments", "lib/activerecord-comments/column_ext.rb", "lib/activerecord-comments/mysql_adapter.rb", "lib/activerecord-comments/base_ext.rb", "lib/activerecord-comments.rb", "spec/mysql_comments_spec.rb", "spec/spec_database.yml", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/remi/activerecord-comments}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Provides an easy to access database table/column comments from ActiveRecord}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
