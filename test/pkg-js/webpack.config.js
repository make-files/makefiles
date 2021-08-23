const {join} = require('path')
const StatsPlugin = require('stats-webpack-plugin')

module.exports = (_, {mode = 'development'} = {}) => {
  const isProduction = mode === 'production'

  return {
    mode,
    output: {
      path: join(__dirname, 'artifacts/webpack/build', mode),
    },
    plugins: [
      new StatsPlugin('.stats.json'),
    ],
  }
}
