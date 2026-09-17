# selenium-automation — Selenium WebDriver (Node / TypeScript / Vitest)

Expert guidance for browser automation and E2E web testing with Selenium
WebDriver in a Node.js / TypeScript stack, driven by Vitest.

**When to use:** writing or reviewing Selenium E2E suites, Page Object Model
layouts, explicit waits/locators, headless Chrome/Firefox/Edge, or migrating
browser tests onto `selenium-webdriver` + Vitest. Not for Playwright, Cypress,
or Python Selenium.

**Needs:** Node.js 22+, a package manager, project deps `selenium-webdriver`,
`@types/selenium-webdriver`, and `vitest`, plus a test browser. Prefer
**Chrome for Testing** and versioned **Firefox** via `npx @puppeteer/browsers`;
**Edge** from Microsoft’s Stable channel; **Safari** only on macOS with
`safaridriver --enable`. Selenium Manager resolves matching drivers.

Install:

```bash
npx skills add drmaas/utility-skills --skill selenium-automation
```

Agent instructions, browser install recommendations, prereq check, POM examples,
waits, and Vitest config: [`SKILL.md`](SKILL.md).
