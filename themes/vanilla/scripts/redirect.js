const generator = (hexo) => ({ posts, pages }) =>
  [
    ...posts
      .filter(({ redirect_from }) => redirect_from)
      .map((page) =>
        (typeof page.redirect_from === "string"
          ? [page.redirect_from]
          : page.redirect_from
        ).map((redirect) => ({ redirect, page }))
      )
      .reduce((result, current) => [...result, ...current], []),
    ...pages
      .filter(({ redirect_from }) => redirect_from)
      .map((page) =>
        (typeof page.redirect_from === "string"
          ? [page.redirect_from]
          : page.redirect_from
        ).map((redirect) => ({ redirect, page }))
      )
      .reduce((result, current) => [...result, ...current], []),
  ].map(({ redirect, page }) => ({
    path: `${redirect}/index.html`,
    data: {
      target: page,
      redirect_from: redirect,
      layout: hexo.config.redirect.layout,
    },
    layout: hexo.config.redirect.layout,
  }));

hexo.config.redirect = Object.assign(
  {
    enable: true,
    layout: "redirect",
  },
  hexo.config.redirect
);

hexo.extend.generator.register("redirect", generator(hexo));
// module.exports = generator;
