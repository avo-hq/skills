#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetches all Tabler icon names from GitHub and prints them to stdout
# in two labeled lines for injection into the menu-icons SKILL.md prompt.
#
# Caches results in icons-cache.json next to this script's parent directory.
# Re-fetches automatically when the cache is older than CACHE_EXPIRY_DAYS.
#
# Usage:
#   ruby scripts/fetch_icons.rb                   # use/refresh cache, output both styles
#   ruby scripts/fetch_icons.rb --force           # ignore cache, re-fetch now
#   ruby scripts/fetch_icons.rb --token ghp_xxx   # with GitHub auth token
#   ruby scripts/fetch_icons.rb --expires 14      # custom expiry in days (default: 30)

require "net/http"
require "uri"
require "json"
require "optparse"
require "time"

REPO             = "tabler/tabler-icons"
CACHE_FILE       = File.expand_path("../icons-cache.json", __dir__)
CACHE_EXPIRY_DAYS = 30

options = { force: false, expires: CACHE_EXPIRY_DAYS }
OptionParser.new do |opts|
  opts.on("--force",          "Ignore cache and re-fetch from GitHub") { options[:force] = true }
  opts.on("--token TOKEN",    "GitHub personal access token")          { |v| options[:token] = v }
  opts.on("--expires DAYS",   "Cache expiry in days (default: 30)")    { |v| options[:expires] = v.to_i }
end.parse!

def cache_valid?(file, force:)
  return false if force
  return false unless File.exist?(file)

  data = JSON.parse(File.read(file))
  expires_at = Time.iso8601(data["expires_at"])
  Time.now.utc < expires_at
rescue
  false
end

def github_get(path, token: nil)
  uri = URI("https://api.github.com/#{path}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  req = Net::HTTP::Get.new(uri)
  req["Accept"]               = "application/vnd.github+json"
  req["User-Agent"]           = "avo-skills/fetch-icons"
  req["X-GitHub-Api-Version"] = "2022-11-28"
  req["Authorization"]        = "Bearer #{token}" if token

  res = http.request(req)
  abort "GitHub API error #{res.code}: #{res.body[0, 200]}" unless res.code == "200"
  JSON.parse(res.body)
end

def fetch_from_github(token:)
  main_tree   = github_get("repos/#{REPO}/git/trees/main", token: token)
  icons_entry = main_tree["tree"].find { |e| e["path"] == "icons" && e["type"] == "tree" }
  abort "Could not find icons/ directory in repository" unless icons_entry

  icons_tree = github_get(
    "repos/#{REPO}/git/trees/#{icons_entry["sha"]}?recursive=1",
    token: token
  )

  warn "WARNING: GitHub truncated the tree response" if icons_tree["truncated"]

  result = {}
  %w[outline filled].each do |style|
    prefix = "#{style}/"
    result[style] = icons_tree["tree"]
      .select { |e| e["type"] == "blob" && e["path"].start_with?(prefix) && e["path"].end_with?(".svg") }
      .map    { |e| e["path"].delete_prefix(prefix).delete_suffix(".svg") }
      .sort
  end
  result
end

# Load from cache or fetch fresh
if cache_valid?(CACHE_FILE, force: options[:force])
  data = JSON.parse(File.read(CACHE_FILE))
  icons = { "outline" => data["outline"], "filled" => data["filled"] }
else
  warn "-> Fetching icons from GitHub..."
  icons = fetch_from_github(token: options[:token])
  warn "-> Fetched #{icons["outline"].size} outline and #{icons["filled"].size} filled icons"

  now        = Time.now.utc
  expires_at = now + (options[:expires] * 86_400)
  cache = {
    "fetched_at" => now.iso8601,
    "expires_at" => expires_at.iso8601,
    "outline"    => icons["outline"],
    "filled"     => icons["filled"]
  }
  File.write(CACHE_FILE, JSON.pretty_generate(cache))
end

if $stdout.tty?
  warn "-> #{icons["outline"].size} outline, #{icons["filled"].size} filled icons available."
else
  puts "outline: #{icons["outline"].join(", ")}"
  puts "filled: #{icons["filled"].join(", ")}"
end
