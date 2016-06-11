(function(window) {
  var Github = function() {
    this.user = {
      token: $("meta[name=github-token]").attr("content"),
      username: $("meta[name=github-username]").attr("content")
    };

    this.get = function(path, params, done) {
      var basicAuth = "Basic " + btoa(this.user.token + ":x-oauth-basic");
      return $.ajax({
        url: "https://api.github.com/" + path,
        method: "GET",
        dataType: "json",
        beforeSend: function (xhr) {
          xhr.setRequestHeader ("Authorization", basicAuth);
          xhr.setRequestHeader ("Accept", "application/vnd.github.v3+json");
          xhr.setRequestHeader ("Content-Type", "application/json");
        },
        xhrFields: {
                     withCredentials: false
        },
        success: done,
        error: done,
      });
    }
  }

  window.Github = Github
})(window);
