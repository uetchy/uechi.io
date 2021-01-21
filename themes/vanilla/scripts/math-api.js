// function filter(config) {
//   return function (content) {
//     return content
//       .replace(
//         /\$\$\n([\w\W]+?)\n\$\$/gm,
//         (_, eq) => `![](https://math.now.sh?from=${encodeURIComponent(eq)})`
//       )
//       .replace(
//         /([\s^])\$(.+?)\$([\s$])/g,
//         (_, s, eq, e) =>
//           `${s}![](https://math.now.sh?inline=${encodeURIComponent(eq)})${e}`
//       );
//   };
// }

// const config = (hexo.config.mathapi = Object.assign(
//   {
//     color: undefined,
//     alternateColor: undefined,
//   },
//   hexo.config.mathapi
// ));

// const mathapi = filter(config);

// hexo.extend.filter.register(
//   "before_post_render",
//   (data) => {
//     // if (!data.mathapi && !config.every_page) return;
//     data.content = mathapi(data.content);
//     return data;
//   },
//   5
// );
