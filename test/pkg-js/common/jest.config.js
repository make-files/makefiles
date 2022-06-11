module.exports = {
  collectCoverageFrom: ["src/**/*.js"],
  coverageDirectory: "artifacts/coverage/jest",
  watchman: false,
  haste: {
    enableSymlinks: true,
  },
};
