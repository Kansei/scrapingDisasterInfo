#! /usr/bin/env ruby
require 'bundler/setup'
require 'mechanize'
require 'open-uri'
require 'json'

class Crawler
  def initialize
    @agent = Mechanize.new
    @rss_url = "http://weather.livedoor.com/forecast/rss/"
  end

  def scraping_earthquake
    earthquake_path = "earthquake.xml"
    earthquakes = scraping(earthquake_path, Earthquake)
    earthquakes.map do |earthquake|
      doc = @agent.get(earthquake.link)
      doc.search('table.normal').each do |table|
        earthquake.date = table.css('tr:nth-child(1) td').inner_text
        earthquake.place = table.css('tr:nth-child(2) td').inner_text.rstrip
        earthquake.magnitude = table.css('tr:nth-child(4) td').inner_text
        earthquake.maximumintensity = table.css('tr:nth-child(5) td').inner_text
      end
      doc.search('#main div table:nth-child(7) tr').each do |area_tr|
        intensity = area_tr.search('td:nth-child(1) strong').inner_text[/震度 \d/]
        area_tr.search('table tr').each do |tr|
          prefecture = tr.search('td:nth-child(1)').inner_text
          tr.search('nobr').each_with_index do |city, i|
            next if i == 0
            earthquake_area = EarthquakeArea.new(
                place: {
                    prefecture: prefecture,
                    city: city.inner_text.split(/\xc2\xa0/)[0]
                },
                date: earthquake.date,
                intensity: intensity
            )
            puts earthquake_area.to_json
          end
        end
      end
      earthquake
    end
  end

  def scraping_volcano
    volcano_path = "volcano.xml"
    volcanos = scraping(volcano_path, Volcano)
    volcanos.map do |volcano|
      doc = @agent.get(volcano.link)
      table = doc.search('.column-inner table.normal')
      if table.size > 1
        area_table = table.first
        area_table.search('tr').each_with_index do |tr, i|
        next if i == 0
          volcano_area = VolcanoArea.new(
              place: tr.search('td:nth-child(1)').inner_text,
              warn_summary: tr.search('td:nth-child(2)').inner_text,
              date: tr.search('td:nth-child(3)').inner_text
          )
          puts volcano_area.to_json
        end
      end

      volcano.warn_summary = doc.search('#mainContent #main .column-inner .warn_summary dd').inner_text
      volcano.place = doc.search('#main > div > div:nth-child(3) > h3').inner_text
      volcano.date = doc.search('#main > div > div.title-outer > ul > li').inner_text
      volcano
    end
  end

  def scraping_tsunami
    tsunami_path = "tsunami.xml"
    tsunamis = scraping(tsunami_path, Tsunami)
    tsunamis.map do |tsunami|
      doc = @agent.get(tsunami.link)
      tsunami.date = doc.search('#main table.normal tr:nth-child(1) td').inner_text
      tsunami.place = doc.search('#main table.normal tr:nth-child(2) td').inner_text.rstrip
      tsunami.magnitude = doc.search('#main table.normal tr:nth-child(4) td').inner_text
      tsunami.description = tsunami.description.split("\n[")[0].split("&gt;\n")[1]

      doc.search('#main table.tableline tr').each do |area_tr|
       next if area_tr.search('td').size == 0
        tsunami_area = TsunamiArea.new(
          place: area_tr.search('td:nth-child(1)').inner_text,
          wave: area_tr.search('td:nth-child(3)').inner_text,
          date: tsunami.date
        )
        puts tsunami_area.to_json
      end
      tsunami
    end
  end


  private

  def scraping(disaster, model)
    doc = @agent.get(@rss_url + disaster)
    disasters = doc.search('item').map do |item|
      # ldWeather:earthquake のとり方がわからない問題
      model.new(
          title: item.search('title').inner_text,
          link: item.search('link').inner_text,
          category: item.search('category').inner_text,
          description: item.search('description').inner_text
      )
    end
    # １つ目のitem内にPRが入ってるため
    disasters[1..-1]
  end
end

class Disaster
  attr_accessor :title, :link, :category, :description, :area, :date, :place

  def initialize(title:, link:, category:, description:)
    @title = title
    @link = link
    @category = category
    @description = description
  end

  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var] = self.instance_variable_get var
    end
    hash.to_json
  end
end

class Volcano < Disaster
  attr_accessor :warn_summary
end

class Earthquake < Disaster
  attr_accessor :maximumintensity, :magnitude
end

class Tsunami < Disaster
  attr_accessor :magnitude
end

class DisasterArea
  attr_accessor :place, :date, :disaster_id

  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var] = self.instance_variable_get var
    end
    hash.to_json
  end
end

class VolcanoArea < DisasterArea
  attr_accessor :warn_summary

  def initialize(place:, date:, warn_summary:)
    @place = place
    @date = date
    @warn_summary = warn_summary
  end
end

class EarthquakeArea < DisasterArea
  attr_accessor :intensity

  def initialize(place:, date:, intensity:)
    @place = place
    @date = date
    @intensity = intensity
  end
end

class TsunamiArea < DisasterArea
  attr_accessor :wave

  def initialize(place:, date:, wave:)
    @place = place
    @date = date
    @wave = wave
  end
end

crawler = Crawler.new
disasters = %w(earthquake volcano tsunami)
disasters.each do |disaster|
  puts disaster.upcase
  items = crawler.send("scraping_#{disaster}")
  items.each do |item|
    puts item.to_json
  end
  puts "======================="
end
