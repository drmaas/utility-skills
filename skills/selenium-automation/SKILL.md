---
name: selenium-automation
description: >-
  Expert guidance for browser automation and web testing with Selenium WebDriver
  in Node.js/TypeScript using Vitest and the `selenium-webdriver` package. Use
  when writing or reviewing Selenium E2E tests, Page Object Model suites,
  waits/locators, headless Chrome/Firefox/Edge, Safari on macOS, or migrating
  browser tests to selenium-webdriver + Vitest. Do NOT use for Playwright,
  Cypress, Puppeteer-as-test-runner, or Python/pytest Selenium — those are
  different stacks.
compatibility: Requires Node.js 22+ (selenium-webdriver ≥4.28 engines), npm/pnpm/yarn, and a test browser. Prefer Chrome for Testing and versioned Firefox via `npx @puppeteer/browsers`; Edge via official install; Safari via macOS `safaridriver`. Uses `selenium-webdriver`, `@types/selenium-webdriver`, and `vitest`.
metadata:
  repository: https://github.com/drmaas/utility-skills
---

# Selenium Browser Automation (Node.js / TypeScript / Vitest)

You are an expert in Selenium WebDriver, browser automation, web testing, and
building reliable automated test suites for web applications using Node.js,
TypeScript, and Vitest with the `selenium-webdriver` package.

## When to use this

- Writing or reviewing Selenium E2E tests in a Node/TypeScript + Vitest project
- Setting up Page Object Model suites with `selenium-webdriver`
- Fixing flaky waits, locators, or driver lifecycle issues
- Pinning Chrome for Testing / Firefox / Edge / Safari for automation

Do **not** activate for Playwright, Cypress, or Python Selenium — use those
ecosystems' own skills/docs instead.

## Workflow

1. Run the Prerequisites check (Node 22+, packages, browser binary)
2. Pin a test browser (Chrome for Testing or Firefox via `@puppeteer/browsers`)
3. Add `createDriver` + Vitest lifecycle (screenshot-on-fail then `quit`)
4. Build page objects on `BasePage` with explicit `until` waits
5. Add `vitest.e2e.config.ts` and a `test:e2e` script
6. Run headless in CI; headed locally when debugging

## Prerequisites

Run this check before scaffolding or debugging Selenium E2E work:

```bash
STATUS=0

echo "=== Node.js ==="
if command -v node >/dev/null 2>&1; then
  VER=$(node -v)
  MAJOR=$(echo "$VER" | sed 's/^v//' | cut -d. -f1)
  echo "  node: found ($VER)"
  if [ "$MAJOR" -lt 22 ]; then
    echo "  need: Node.js 22+ (selenium-webdriver engines)"
    STATUS=1
  fi
else
  echo "  node: NOT FOUND"
  STATUS=1
fi

echo "=== Package manager ==="
if command -v pnpm >/dev/null 2>&1; then
  echo "  pnpm: found ($(pnpm -v))"
elif command -v npm >/dev/null 2>&1; then
  echo "  npm: found ($(npm -v))"
elif command -v yarn >/dev/null 2>&1; then
  echo "  yarn: found ($(yarn -v))"
else
  echo "  package manager: NOT FOUND"
  STATUS=1
fi

echo "=== Project packages ==="
if [ -f package.json ]; then
  if node -e "require.resolve('selenium-webdriver')" 2>/dev/null; then
    echo "  selenium-webdriver: FOUND"
  else
    echo "  selenium-webdriver: MISSING (npm i -D selenium-webdriver)"
    STATUS=1
  fi
  if node -e "require.resolve('@types/selenium-webdriver/package.json')" 2>/dev/null; then
    echo "  @types/selenium-webdriver: FOUND"
  else
    echo "  @types/selenium-webdriver: MISSING (npm i -D @types/selenium-webdriver)"
    STATUS=1
  fi
  if node -e "require.resolve('vitest')" 2>/dev/null; then
    echo "  vitest: FOUND"
  else
    echo "  vitest: MISSING (npm i -D vitest)"
    STATUS=1
  fi
else
  echo "  package.json: NOT FOUND (run from project root after init)"
  STATUS=1
fi

echo "=== Browsers ==="
BROWSER_FOUND=0
for bin in google-chrome google-chrome-stable chromium chromium-browser chrome firefox msedge microsoft-edge microsoft-edge-stable; do
  if command -v "$bin" >/dev/null 2>&1; then
    echo "  $bin: FOUND"
    BROWSER_FOUND=1
  fi
done
if command -v safaridriver >/dev/null 2>&1; then
  echo "  safaridriver: FOUND (macOS Safari)"
  BROWSER_FOUND=1
fi
# Only count puppeteer cache if list shows an installed chrome/firefox build
if command -v npx >/dev/null 2>&1; then
  if LIST=$(npx --yes @puppeteer/browsers list 2>/dev/null) && echo "$LIST" | grep -Eqi 'chrome@|firefox@'; then
    echo "  @puppeteer/browsers: installed chrome/firefox build(s)"
    echo "$LIST" | grep -Ei 'chrome@|firefox@' | head -5 | sed 's/^/    /'
    BROWSER_FOUND=1
  else
    echo "  @puppeteer/browsers: no chrome/firefox build listed (hint only)"
  fi
fi
if [ "$BROWSER_FOUND" -eq 0 ]; then
  echo "  browser: NOT FOUND — see Recommended test browsers below"
  STATUS=1
fi

exit $STATUS
```

## Recommended test browsers

Prefer **versioned, non–auto-updating test binaries** over the everyday browser
you browse with. Selenium Manager still resolves matching drivers; you point
Options at the test binary when it is not on `PATH`.

### Chrome — Chrome for Testing (preferred)

Dedicated Chrome flavor for automation: versioned, no auto-update, paired with
ChromeDriver per channel. Docs:
[Download Chrome for Testing binaries](https://developer.chrome.com/docs/automation-and-testing/download-test-binaries).

```bash
# CI-friendly: auto-confirm npx package install
npx --yes @puppeteer/browsers install chrome@stable

# Pin a milestone or exact build
npx --yes @puppeteer/browsers install chrome@131
npx --yes @puppeteer/browsers install chrome@131.0.6778.85

# Matching ChromeDriver when you need an explicit path (Selenium Manager usually enough)
npx --yes @puppeteer/browsers install chromedriver@stable

# Ubuntu/Debian only: also install system deps for CfT (requires root)
# npx --yes @puppeteer/browsers install chrome@stable --install-deps
```

CLI prints the install path. Export it as `CHROME_BIN` and point Selenium at it:

```typescript
import chrome from 'selenium-webdriver/chrome.js';

const options = new chrome.Options();
options.setChromeBinaryPath(process.env.CHROME_BIN!);
options.addArguments('--headless=new', '--window-size=1280,720');
// In Docker/CI-as-root only:
// options.addArguments('--no-sandbox', '--disable-dev-shm-usage');
```

**Manual ZIP download (browser download, not the CLI):** on macOS Gatekeeper may
block launch — run `xattr -cr 'Google Chrome for Testing.app'`. The
`@puppeteer/browsers` CLI does not need this.

Dashboard / JSON APIs: [chrome-for-testing](https://googlechromelabs.github.io/chrome-for-testing/).
Do **not** use random Chromium mirrors for production CI — prefer CfT.

### Firefox — versioned binary via `@puppeteer/browsers` (preferred)

Mozilla has no separate “Firefox for Testing” brand like Chrome. Best practice
for Selenium: install a **pinned Firefox Stable** with the same CLI, then set
the binary. GeckoDriver is handled by Selenium Manager.

```bash
npx --yes @puppeteer/browsers install firefox@stable
npx --yes @puppeteer/browsers install firefox@133.0
```

```typescript
import firefox from 'selenium-webdriver/firefox.js';

const options = new firefox.Options();
options.setBinary(process.env.FIREFOX_BIN!);
options.addArguments('-headless');
```

Alternatives (worse for CI pinning):

- System package (`apt`/`brew`/`winget`) — drifts on update; OK for local smoke only
- Selenium Manager browser download when no Firefox is installed — convenient, less explicit than pinning via `@puppeteer/browsers`

Linux note: unpacking Firefox archives via `@puppeteer/browsers` needs `xz` /
`bzip2` on `PATH`.

### Edge — Stable / channel install + Selenium Manager

There is **no** Chrome-for-Testing equivalent for Edge. Use official Microsoft
Edge channels and let Selenium Manager fetch matching `msedgedriver`.

| Goal | Recommendation |
| --- | --- |
| Local / CI default | Microsoft Edge **Stable** |
| Early coverage | Edge Beta / Dev / Canary |
| Driver | Selenium Manager (default); or [Edge WebDriver downloads](https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/) if pinning manually |

```bash
# macOS
brew install --cask microsoft-edge

# Windows (winget)
winget install --id Microsoft.Edge -e

# Debian/Ubuntu — Microsoft package repo, then:
# sudo apt-get install microsoft-edge-stable
```

```typescript
import edge from 'selenium-webdriver/edge.js';

const options = new edge.Options();
if (process.env.EDGE_BIN) {
  options.setEdgeChromiumBinaryPath(process.env.EDGE_BIN);
}
options.addArguments('--headless=new');
// In Docker/CI-as-root only:
// options.addArguments('--no-sandbox', '--disable-dev-shm-usage');
```

Windows CI is the path of least resistance for Edge. On Linux/macOS, install the
official Edge package (or rely on Selenium Manager’s browser download where
supported). Pin major version in CI images when reproducibility matters.

### Safari — macOS only (`safaridriver`)

Safari is **not** downloadable as a portable test binary. Automation uses the
OS-bundled Safari + `safaridriver`.

```bash
# Once per machine (may need sudo after macOS upgrades)
safaridriver --enable
```

Also enable **Develop → Allow Remote Automation** in Safari when required.

```typescript
import { describe, it } from 'vitest';
import { Builder, Browser } from 'selenium-webdriver';
import safari from 'selenium-webdriver/safari.js';

describe('Safari', () => {
  it.skipIf(process.platform !== 'darwin')('loads blank page', async () => {
    const options = new safari.Options();
    // Safari Technology Preview (optional):
    // options.setTechnologyPreview(true);
    const driver = await new Builder()
      .forBrowser(Browser.SAFARI)
      .setSafariOptions(options)
      .build();
    try {
      await driver.get('https://www.selenium.dev/selenium/web/blank.html');
    } finally {
      await driver.quit();
    }
  });
});
```

**Safari Technology Preview** (newer WebKit, still macOS-only): install from
[Apple — Safari Technology Preview](https://developer.apple.com/safari/technology-preview/),
then `options.setTechnologyPreview(true)` (see
[Selenium Safari docs](https://www.selenium.dev/documentation/webdriver/browsers/safari/)).

Constraints:

- macOS hosts only (no Linux Safari)
- No portable version pin like CfT — OS / STP version *is* the pin
- Limited / no classic headless; plan headed or remote macOS runners
- iOS Safari → Appium, not desktop `safaridriver`

### Quick pick matrix

| Browser | Best test install | Pinning | Headless |
| --- | --- | --- | --- |
| Chrome | Chrome for Testing via `@puppeteer/browsers` | Excellent (`chrome@stable` / build id) | Yes (`--headless=new`) |
| Firefox | `@puppeteer/browsers install firefox@…` | Good (version / build id) | Yes (`-headless`) |
| Edge | Official Edge Stable (+ Selenium Manager) | Fair (image / package version) | Yes (`--headless=new`) |
| Safari | System Safari + `safaridriver --enable` | OS / Technology Preview only | Limited |

Default local/CI stack: **Chrome for Testing** + optional **Firefox** from
`@puppeteer/browsers`. Add Edge for Chromium-Edge specifics; add Safari on
macOS runners when WebKit coverage is required.

## Core Expertise

- Selenium WebDriver architecture and browser drivers (Selenium Manager)
- Element location strategies (testid, ID, CSS, XPath, link text, name)
- Explicit waits for dynamic content (`driver.wait` + `until`)
- Page Object Model (POM) design pattern
- Cross-browser testing with Chrome, Firefox, Safari, Edge
- Headless browser execution
- Integration with Vitest
- Grid / remote WebDriver for parallel or CI execution

## Key Principles

- Write maintainable TypeScript with async/await throughout
- Implement the Page Object Model for reusable page interactions
- Prefer explicit waits over implicit waits or hard-coded sleeps
- Design tests for independence and isolation (fresh driver per test)
- Handle dynamic content and asynchronous UI properly
- Follow DRY with shared helpers and a base page class

## Project Structure

```
e2e/
  setup/
    driver.ts
    vitest.setup.ts
  pages/
    base-page.ts
    login-page.ts
    dashboard-page.ts
  login.test.ts
  dashboard.test.ts
vitest.e2e.config.ts
```

## WebDriver Setup

Selenium Manager (bundled with modern `selenium-webdriver`) resolves browser
drivers automatically — no separate `webdriver-manager` package.

### Driver Factory

```typescript
import { Builder, Browser, type WebDriver } from 'selenium-webdriver';
import chrome from 'selenium-webdriver/chrome.js';
import firefox from 'selenium-webdriver/firefox.js';
import edge from 'selenium-webdriver/edge.js';
import safari from 'selenium-webdriver/safari.js';

export type BrowserName = 'chrome' | 'firefox' | 'edge' | 'safari';

function inContainerOrCi(): boolean {
  return Boolean(process.env.CI) || Boolean(process.env.SELENIUM_IN_DOCKER);
}

export async function createDriver(
  browser: BrowserName = (process.env.SELENIUM_BROWSER as BrowserName) || 'chrome',
  headless = true,
): Promise<WebDriver> {
  if (browser === 'safari') {
    if (process.platform !== 'darwin') {
      throw new Error('Safari WebDriver requires macOS (safaridriver)');
    }
    return new Builder()
      .forBrowser(Browser.SAFARI)
      .setSafariOptions(new safari.Options())
      .build();
  }

  if (browser === 'chrome') {
    const options = new chrome.Options();
    if (process.env.CHROME_BIN) {
      options.setChromeBinaryPath(process.env.CHROME_BIN);
    }
    if (headless) {
      options.addArguments('--headless=new');
    }
    options.addArguments('--window-size=1280,720');
    if (inContainerOrCi()) {
      options.addArguments('--no-sandbox', '--disable-dev-shm-usage');
    }
    return new Builder()
      .forBrowser(Browser.CHROME)
      .setChromeOptions(options)
      .build();
  }

  if (browser === 'firefox') {
    const options = new firefox.Options();
    if (process.env.FIREFOX_BIN) {
      options.setBinary(process.env.FIREFOX_BIN);
    }
    if (headless) {
      options.addArguments('-headless');
    }
    return new Builder()
      .forBrowser(Browser.FIREFOX)
      .setFirefoxOptions(options)
      .build();
  }

  const options = new edge.Options();
  if (process.env.EDGE_BIN) {
    options.setEdgeChromiumBinaryPath(process.env.EDGE_BIN);
  }
  if (headless) {
    options.addArguments('--headless=new');
  }
  if (inContainerOrCi()) {
    options.addArguments('--no-sandbox', '--disable-dev-shm-usage');
  }
  return new Builder()
    .forBrowser(Browser.EDGE)
    .setEdgeOptions(options)
    .build();
}
```

Set `CHROME_BIN` / `FIREFOX_BIN` / `EDGE_BIN` to paths printed by
`npx @puppeteer/browsers install …` (or your Edge package path). Leave unset
to use Selenium Manager’s discovery of a system browser. Optional:
`SELENIUM_BROWSER=chrome|firefox|edge|safari`, `SE_CHROME_PATH` /
`SE_FIREFOX_PATH` / `SE_EDGE_PATH` (Selenium Manager env vars).

### Vitest Lifecycle (quit + screenshot together)

Combine failure screenshot and `quit()` in **one** `afterEach`. Do not use
`onTestFailed` for screenshots — it runs after `afterEach`, when the session is
already gone.

```typescript
import { beforeEach, afterEach } from 'vitest';
import { mkdirSync, writeFileSync } from 'node:fs';
import type { WebDriver } from 'selenium-webdriver';
import { createDriver } from './setup/driver.js';

let driver: WebDriver;

beforeEach(async () => {
  driver = await createDriver('chrome', true);
});

afterEach(async (context) => {
  try {
    if (context.task.result?.state === 'fail' && driver) {
      const png = await driver.takeScreenshot();
      mkdirSync('e2e/artifacts', { recursive: true });
      const name = context.task.name.replace(/\W+/g, '_');
      writeFileSync(`e2e/artifacts/${name}.png`, png, 'base64');
    }
  } finally {
    if (driver) {
      await driver.quit();
    }
  }
});

export function getDriver(): WebDriver {
  return driver;
}
```

Prefer **function-scoped** drivers (create in `beforeEach`, quit in `afterEach`)
so tests stay isolated. Avoid sharing one browser across an entire file unless
startup cost forces it — then reset cookies/storage between tests.

## Page Object Model

### Base Page Class

```typescript
import {
  type WebDriver,
  type WebElement,
  type Locator,
  until,
} from 'selenium-webdriver';

const DEFAULT_TIMEOUT_MS = 10_000;

export class BasePage {
  constructor(
    protected readonly driver: WebDriver,
    protected readonly timeoutMs = DEFAULT_TIMEOUT_MS,
  ) {}

  async findElement(locator: Locator): Promise<WebElement> {
    await this.driver.wait(until.elementLocated(locator), this.timeoutMs);
    return this.driver.findElement(locator);
  }

  async clickElement(locator: Locator): Promise<void> {
    const element = await this.findElement(locator);
    await this.driver.wait(until.elementIsVisible(element), this.timeoutMs);
    await this.driver.wait(until.elementIsEnabled(element), this.timeoutMs);
    await element.click();
  }

  async enterText(locator: Locator, text: string): Promise<void> {
    const element = await this.findElement(locator);
    await this.driver.wait(until.elementIsVisible(element), this.timeoutMs);
    await this.driver.wait(until.elementIsEnabled(element), this.timeoutMs);
    await element.clear();
    await element.sendKeys(text);
  }
}
```

### Page Object Implementation

```typescript
import { By, type WebDriver } from 'selenium-webdriver';
import { BasePage } from './base-page.js';

const BASE_URL = process.env.BASE_URL ?? 'https://example.com';

export class LoginPage extends BasePage {
  // First-party apps: prefer data-testid over structural CSS/IDs
  static readonly USERNAME_INPUT = By.css('[data-testid="username"]');
  static readonly PASSWORD_INPUT = By.css('[data-testid="password"]');
  static readonly LOGIN_BUTTON = By.css('[data-testid="login-submit"]');
  static readonly ERROR_MESSAGE = By.css('[data-testid="login-error"]');

  readonly path = '/login';

  constructor(driver: WebDriver) {
    super(driver);
  }

  async navigate(): Promise<void> {
    await this.driver.get(`${BASE_URL}${this.path}`);
  }

  async login(username: string, password: string): Promise<void> {
    await this.enterText(LoginPage.USERNAME_INPUT, username);
    await this.enterText(LoginPage.PASSWORD_INPUT, password);
    await this.clickElement(LoginPage.LOGIN_BUTTON);
  }

  async getErrorMessage(): Promise<string> {
    const el = await this.findElement(LoginPage.ERROR_MESSAGE);
    return el.getText();
  }
}
```

## Element Location Strategies

### Preferred Order

**First-party apps you control**

1. **`[data-testid]`** — stable contract for automation
2. **Accessible name / role** (when exposed) — resilient UX-aligned locators
3. **ID** — good when stable and unique
4. **Name** — form controls
5. **CSS** — prefer attributes over deep structure
6. **XPath** — last resort for complex relationships

**Third-party / legacy pages (no testids)**

1. **ID** → **Name** → **CSS** → **XPath** → **Link Text**
2. Avoid class-only selectors that change with design systems

### CSS Selector Best Practices

```typescript
import { By } from 'selenium-webdriver';

// Good: stable hooks
By.css('[data-testid="submit-button"]');
By.css('form#login input[name="username"]');

// Avoid: fragile selectors
By.css('div > div > div > button'); // too structural
By.css('.btn-primary'); // class might change
```

### XPath Best Practices

```typescript
By.xpath('//label[text()="Email"]/following-sibling::input');
By.xpath('//table//tr[contains(., "John")]//button[@class="edit"]');
```

## Waits and Synchronization

### Explicit Waits (Preferred)

```typescript
import { By, until, type WebDriver, error } from 'selenium-webdriver';

async function waitExamples(driver: WebDriver): Promise<void> {
  const timeoutMs = 10_000;

  // Wait until located, then interact
  await driver.wait(until.elementLocated(By.id('button')), timeoutMs);
  const button = await driver.findElement(By.id('button'));
  await driver.wait(until.elementIsEnabled(button), timeoutMs);
  await button.click();

  // Wait until visible
  await driver.wait(until.elementLocated(By.id('modal')), timeoutMs);
  const modal = await driver.findElement(By.id('modal'));
  await driver.wait(until.elementIsVisible(modal), timeoutMs);

  // Wait for text: locate inside the wait chain (do not findElement before wait)
  const status = await driver.wait(until.elementLocated(By.id('status')), timeoutMs);
  await driver.wait(until.elementTextContains(status, 'Complete'), timeoutMs);

  // Custom condition: catch missing elements so wait can retry
  await driver.wait(async (d) => {
    try {
      const text = await d.findElement(By.id('count')).getText();
      return text === '5';
    } catch (err) {
      if (err instanceof error.NoSuchElementError) return false;
      throw err;
    }
  }, timeoutMs);
}
```

Avoid `driver.sleep(...)` except as a last-resort debug aid. Prefer
`until.elementLocated`, `until.elementIsVisible`, `until.elementIsEnabled`,
`until.stalenessOf`, and `until.ableToSwitchToFrame`.

### Common `until` Conditions

- `elementLocated` — element exists in the DOM
- `elementIsVisible` — element is displayed
- `elementIsEnabled` — element can be interacted with
- `stalenessOf` — element is no longer attached
- `ableToSwitchToFrame` — frame is available
- `elementTextContains` / `elementTextIs` — text assertions via wait

Implicit waits (`await driver.manage().setTimeouts({ implicit: ms })`) make
failures harder to diagnose; prefer explicit waits in page objects.

## Test Writing Best Practices

### Test Structure (Vitest)

```typescript
import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { mkdirSync, writeFileSync } from 'node:fs';
import type { WebDriver } from 'selenium-webdriver';
import { createDriver } from './setup/driver.js';
import { LoginPage } from './pages/login-page.js';
import { DashboardPage } from './pages/dashboard-page.js';

describe('Login', () => {
  let driver: WebDriver;
  let loginPage: LoginPage;
  let dashboardPage: DashboardPage;

  beforeEach(async () => {
    driver = await createDriver('chrome', true);
    loginPage = new LoginPage(driver);
    dashboardPage = new DashboardPage(driver);
  });

  afterEach(async (context) => {
    try {
      if (context.task.result?.state === 'fail' && driver) {
        const png = await driver.takeScreenshot();
        mkdirSync('e2e/artifacts', { recursive: true });
        writeFileSync(
          `e2e/artifacts/${context.task.name.replace(/\W+/g, '_')}.png`,
          png,
          'base64',
        );
      }
    } finally {
      await driver.quit();
    }
  });

  it('allows login with valid credentials', async () => {
    await loginPage.navigate();
    await loginPage.login('valid_user', 'valid_pass');
    expect(await dashboardPage.isDisplayed()).toBe(true);
  });

  it('shows an error for invalid password', async () => {
    await loginPage.navigate();
    await loginPage.login('valid_user', 'wrong_pass');
    expect(await loginPage.getErrorMessage()).toContain('Invalid credentials');
  });
});
```

### Test Naming Conventions

- Use descriptive names: `allows login with valid credentials and redirects to dashboard`
- Include the action and expected outcome
- Group related cases in `describe` blocks (`describe('smoke: login', ...)`)

## Handling Special Elements

### Dropdowns

`Select` works with native `<select>` elements only. Custom comboboxes need
click / keyboard interactions on the visible control.

```typescript
import { By, Select, type WebDriver } from 'selenium-webdriver';

async function selectCountry(driver: WebDriver): Promise<void> {
  const element = await driver.findElement(By.id('country'));
  const select = new Select(element);
  await select.selectByVisibleText('United States');
  await select.selectByValue('us');
  await select.selectByIndex(1);
}
```

### Alerts

```typescript
const alert = await driver.switchTo().alert();
await alert.accept(); // OK
await alert.dismiss(); // Cancel
await alert.sendKeys('input text'); // prompt
```

### Frames

```typescript
await driver.switchTo().frame('frame_name');
// Or by element
const frame = await driver.findElement(By.id('myframe'));
await driver.switchTo().frame(frame);
await driver.switchTo().defaultContent();
```

### Multiple Windows / Tabs

```typescript
const originalWindow = await driver.getWindowHandle();
await driver.switchTo().newWindow('tab');
// ... work in new tab
await driver.close();
await driver.switchTo().window(originalWindow);

// Or switch to a handle opened by a click
const handles = await driver.getAllWindowHandles();
for (const handle of handles) {
  if (handle !== originalWindow) {
    await driver.switchTo().window(handle);
    break;
  }
}
```

## Performance and Reliability

- Run tests headless in CI for speed and stability
- Cap Vitest parallelism for browser tests (`fileParallelism: false` or low `maxWorkers`)
- Retry only known-flaky cases; fix root waits first
- Capture screenshots on failure **before** `driver.quit()`
- Use `driver.wait(until...)` instead of `driver.sleep()`

## Key Dependencies

```bash
npm i -D selenium-webdriver @types/selenium-webdriver vitest typescript @types/node
```

- `selenium-webdriver` — WebDriver client (includes Selenium Manager); needs Node 22+
- `@types/selenium-webdriver` — TypeScript typings (not bundled in the package)
- `vitest` — test runner
- `typescript` / `@types/node` — typed page objects and `node:fs` helpers

Optional: HTML reporters via Vitest UI / third-party reporters; remote Grid via
`Builder().usingServer(gridUrl)`.

## Configuration

```typescript
// vitest.e2e.config.ts
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    include: ['e2e/**/*.test.ts'],
    testTimeout: 60_000,
    hookTimeout: 60_000,
    fileParallelism: false, // safer default for local browsers
    // maxWorkers: 2, // raise carefully in CI with Grid/containers
    setupFiles: ['e2e/setup/vitest.setup.ts'],
  },
});
```

```json
// package.json scripts
{
  "scripts": {
    "test:e2e": "vitest run --config vitest.e2e.config.ts"
  }
}
```

Group suites with nested `describe` names (e.g. `describe('smoke', ...)`,
`describe('regression', ...)`) and filter with Vitest's `-t` / pattern flags.

## Edge Cases

- **Empty puppeteer cache dir** — does not mean a browser is installed; use
  `npx @puppeteer/browsers list` or a binary on `PATH`
- **Linux CfT crash on missing libs** — reinstall with `--install-deps` (root)
- **Safari off macOS** — skip with `it.skipIf(process.platform !== 'darwin')`
- **Grid / remote** — `new Builder().usingServer(process.env.SELENIUM_REMOTE_URL).…`
- **Browser selection** — `SELENIUM_BROWSER` or pass into `createDriver`
- **Session already quit** — never screenshot after `quit()`; use one `afterEach`
  with `try` / `finally`
- **Custom dropdowns** — `Select` only for native `<select>`; otherwise POM clicks
- **Older Node** — if stuck on Node 18/20, pin `selenium-webdriver@<4.28` (not
  recommended); prefer upgrading to Node 22+

## Debugging Tips

- Disable headless (`createDriver('chrome', false)`) to watch the browser
- Prefer the combined failure-screenshot `afterEach` over ad-hoc captures
- Inspect DOM: `console.log(await driver.getPageSource())`
- Attach a debugger: `node --inspect-brk ./node_modules/vitest/vitest.mjs run --config vitest.e2e.config.ts`
- Confirm locators in DevTools before encoding them in page objects
