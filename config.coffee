config =

    development:
        lists:
            base_uri: "http://api.matt1.local:5000"
            user_agent: "ListWidgetAPI/1.0"

    production:
        lists:
            base_uri: "http://api.matthax-list-api-enpoints.spinner.10.10.10.57.xip.io"
            user_agent: "ListWidgetAPI/1.0"


module.exports = config[process.env.NODE_ENV ? "production"]
