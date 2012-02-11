#!/usr/bin/ruby -Ku

require 'sinatra'
require './db'

get '/' do
  ret = <<-EOD
    <html>
      <head>
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <script type="text/javascript">
          google.load("visualization", "1", {packages:["corechart"]});
          google.setOnLoadCallback(drawChart);
          function drawChart() {
  EOD
  
  users = User.find(:all)

  users.each do |user|
    rows = user.user_infos.map do |e| "['#{e.created_at.strftime("%m-%d %H:%M")}', #{e.followers_count}]" end

    ret += <<-EOD
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'date');
            data.addColumn('number', 'followers');
            data.addRows([
              #{rows.join(',')}
            ]);

            var options = {
              width: 800, height: 360,
              title: '#{user.screen_name}',
              vAxis: {title: 'Followers',  titleTextStyle: {color: 'black'}},
              legend: {position: 'none'}
            };

            var chart = new google.visualization.AreaChart(document.getElementById('#{user.screen_name}'));
            chart.draw(data, options);
    EOD
  end

  ret += <<-EOD
          }
        </script>
      </head>
      <body>
        <div id='1000favs_RT'></div>
        <div id='1000favs'></div>
        <div id='100favs_RT'></div>
        <div id='100favs'></div>
        <div id='1000Retweets_RT'></div>
        <div id='1000Retweets'></div>
        <div id='nicklegr'></div>
      </body>
    </html>
  EOD
  
  ret
end