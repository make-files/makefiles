import { join } from "path";

export function createConfig (rootPath, {StatsWriterPlugin}) {
  return (_, { mode = "development" } = {}) => {
    const isProduction = mode === "production";
    const { JS_WEBPACK_BUILD_NAME: buildName = "" } = process.env;

    return {
      mode,
      output: {
        path: buildName
          ? join(rootPath, "artifacts/webpack/build/named", buildName, mode)
          : join(rootPath, "artifacts/webpack/build", mode),
      },
      plugins: [new StatsWriterPlugin({ filename: ".stats.json" })],
    };
  };
}
