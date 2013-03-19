# Marmot — Unofficial [Font Squirrel Webfont Generator](http://www.fontsquirrel.com/tools/webfont-generator/) Client 

Marmot automates font-face generation, making it easier and faster:

    marmot Averia-Regular.ttf         # ls .   =>   webfontkit.zip

Marmot supports Font Squirrel configuration files:

    marmot  -c generator-config.txt  font.otf

It is especially useful when it comes to your own icon fonts:

    marmot  -c config.txt  my-icon-font.otf  my-icon-font.zip

###Great, how do I install Marmot?

Marmot is a ruby gem:

    gem install marmot

###Okay, how do I configure it?

Font Squirrel Webfont Generator has **a lot of** options and by default Marmot will use default ones.

Every Font Squirrel webfont kit comes with a text file called **generator_config.txt**. Marmot can read it:

    marmot  -c generator-config.txt  font.otf

Since the config is actually just a JSON file, you can write your own configs. I use this one for my icons:
```json
{
  "formats":["ttf", "woff", "svg"],
  "fallback":"none",
  "subset_custom_range":"E000-F8FF",
  "emsquare":"1000"
}
```

You can do the same thing from the command line:

    marmot  --no-add-hyphens  --formats=ttf,woff  font.otf

Here is a full list of options:

```bash
                         --mode <s>
                      --formats <s> 
                --tt-instructor <s> 
             --fix-vertical-metrics
                         --fix-gasp
                   --remove-kerning
                       --add-spaces
                      --add-hyphens
                     --fallback <s>
              --fallback-custom <i>
                          --webonly
               --options-subset <s>
                 --subset-range <s>
                --subset-custom <s>
          --subset-custom-range <s>
                           --base64
                       --style-link
               --css-stylesheet <s>
                  --ot-features <s>
              --filename-suffix <s>
                     --emsquare <i>
           --spacing-adjustment <i>
                        --agreement
```

###Oh, this is great, but what is "tt-instuctor" or "subset-custom"?

Some option names can be confusing. Go to [generator's page](http://www.fontsquirrel.com/tools/webfont-generator) and run this in the console:

```js
  $("input[value='expert'], input[value='advanced']").click();
  $("table input").each(function(){
    $(this).after($("<div style='color:red;'>"+$(this).attr("name")+" : "+$(this).attr("value")+"</div>"));
  });
```
![Options](https://raw.github.com/petethepig/marmot/master/doc/js-snippet.png)

###What else?
Since Marmot is a ruby gem, you can use it in your ruby projects:
```ruby
require 'marmot'

client = Marmot::Client.new
client.convert File.new("font.ttf"), { 
  formats: ["ttf", "woff"] 
}
```

###I found a lousy bug, what do I do?

Marmot is only a couple days old, so this can happen. Please, report on the [Issues page](https://github.com/petethepig/marmot/issues).

Or [contact me on Twitter](https://twitter.com/dmi3f)

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/37f28361c2ec4bf7ff7b8a9bc3655929 "githalytics.com")](http://githalytics.com/petethepig/marmot)
