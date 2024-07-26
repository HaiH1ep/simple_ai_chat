# README

* Ruby version 3.2.2
* Rails version 7.1.3

You need to add your OpenAI API key
```
OPENAI_ACCESS_TOKEN="sk-None-your_key"
```

Run bundle + migrate and run bin/dev
```
bin/dev
```

My main feature is using OpenAI API and convert CSV to json to upload, you can find here
I'm not too focus on UI so you can see it's quite simple but it's enough to use

[CsvCleanup](https://github.com/HaiH1ep/simple_ai_chat/blob/main/app/services/csv_cleanup.rb)
[OpenaiService](https://github.com/HaiH1ep/simple_ai_chat/blob/main/app/services/openai_service.rb)

I'm using RSpec for testing, you can run with
```
bundle exec rspec spec/*
```
