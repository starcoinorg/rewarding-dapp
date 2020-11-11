module.exports = {
  configureWebpack: {
    module: {
      rules: [
        {
          test: /\.mv$/i,
          use: [
            {
              loader: "url-loader",
              options: {
                limit: false,
                encoding: false,
                mimetype: "application/octet-stream"
              }
            }
          ]
        }
      ]
    }
  }
};
