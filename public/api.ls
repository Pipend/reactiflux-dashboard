require! \../config.ls

# get-channels :: () -> p [String]
export get-channels = ->
    fetch "#{config.pipe.url}/apis/branches/pBtfJqR/execute/3600/transformation"
      .then (.json!)