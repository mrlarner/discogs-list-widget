config =

    development:
        lists:
            base_uri: "http://api.matthax-list-api-enpoints.spinner.10.10.10.57.xip.io"
            user_agent: "ListWidgetAPI/1.0"
        list_widget:
            base_uri: "http://localhost:3000/lists"

    production:
        lists:
            base_uri: "http://api.matthax-list-api-enpoints.spinner.10.10.10.57.xip.io"
            user_agent: "ListWidgetAPI/1.0"
        list_widget:
            base_uri: "/lists"

module.exports = config[process.env.NODE_ENV ? "production"]
