const {join} = require('path')
const StatsPlugin = require('stats-webpack-plugin')

module.exports = (_, {mode = 'development'} = {}) => {
  const isProduction = mode === 'production'
  const {JS_WEBPACK_BUILD_NAME: buildName = ''} = process.env

  return {
    mode,
    output: {
      path: buildName
        ? join(__dirname, 'artifacts/webpack/build/named', buildName, mode)
        : join(__dirname, 'artifacts/webpack/build', mode),
    },
    plugins: [
      new StatsPlugin('.stats.json'),
    ],
  }
}
