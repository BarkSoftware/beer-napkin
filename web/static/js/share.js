(function(){
  beer.Share = function(napkin) {
    this.napkin = napkin;
    var button = $("#share-button");
    var git = new Github();
    var model = this;
    $("#share-modal").modal({show: false});

    var share = _.bind(function() {
      model.repo = "";
      $("#share-modal").modal('toggle');
      $("#napkin-image-link")
        .attr("href", this.napkin.image_url)
        .text(this.napkin.image_url);
      $("#copy-image-link")
        .attr("data-clipboard-text", this.napkin.image_url);
      new Clipboard("#copy-image-link");
    }, this);

    //setup repository search
    $("#repository-search").typeahead({
      delay: 500,
      afterSelect: function(item) {
        model.repo = item.name;
      },
      matcher: function(i) { return true; },
      source: function(q, process) {
        git.get("search/repositories?q=" + q, {}, function(result) {
          if (!result) {
            debugger;
          }
          var items = [];
          if (result && result.items) {
            var repos = result.items;
            items = _.map(repos, function(r) {
              return { id: r.id, name: r.full_name };
            });
          }
          process(items);
        });
      }
    });

    //setup create as issue button
    $("#create-as-issue").click(function() {
      var repository = $("#repository-search").val();
      var issue_title = $("#issue-title").val();
      var issue_description = $("#issue-description").val();
      $("#napkin_repository_full_name").val(repository);
      $("#napkin_issue_title").val(issue_title);
      $("#napkin_issue_description").val(issue_description);
      var form = $("#save-form");
      form.submit();
    });

    if ($("#napkin_image_url").val().length) {
      $("#share-image-container").show();
    }
    else {
      $("#share-image-container").hide();
    }

    button.click(share);
  }
})();
