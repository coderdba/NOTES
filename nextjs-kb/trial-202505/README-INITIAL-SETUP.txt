=================================
REFERENCES
=================================
NextJS:
https://nextjs.org/docs/app/getting-started/installation

Tutorials:
https://www.tutorialspoint.com/nextjs/index.htm

=================================
NODE JS VERSION INSTALL
=================================

-------------
Install nvm
-------------
NVM helps install and use different Nodejs versions easily.

Steps:
https://github.com/coreybutler/nvm-windows/releases

-------------
Install Node
-------------
nvm install 23.11.0

nvm list
    23.11.0
    20.14.0
    16.19.0

nvm use 23.11.0

node --version
v23.11.0

---------------
Install NextJS
---------------
https://github.com/vercel/next.js/discussions/35794


========================
VERIFY
========================
NOTE: The folder C:\Program Files\nodejs will point to appropriate version's folder in AppData\Roaming depending upon "nvm use" setup.

where node
C:\Program Files\nodejs\node.exe

where npx
C:\Program Files\nodejs\npx
C:\Program Files\nodejs\npx.cmd

where npm
C:\Program Files\nodejs\npm
C:\Program Files\nodejs\npm.cmd

where nvm
C:\Users\GSM078\AppData\Roaming\nvm\nvm.exe

================================================
CREATE THE APP - with "latest" tag
================================================
This installed the following versions:
  "dependencies": {
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "next": "15.3.2"
  },


STEPS:

npx create-next-app@latest
√ What is your project named? ... myapp
√ Would you like to use TypeScript? ... No / Yes
√ Would you like to use ESLint? ... No / Yes
√ Would you like to use Tailwind CSS? ... No / Yes
√ Would you like your code inside a `src/` directory? ... No / Yes
√ Would you like to use App Router? (recommended) ... No / Yes
√ Would you like to use Turbopack for `next dev`? ... No / Yes
√ Would you like to customize the import alias (`@/*` by default)? ... No / Yes
Creating a new Next.js app in C:\Users\myuser\mygit\myapp.

Using npm.

Initializing project with template: app-tw

Installing dependencies:
- react
- react-dom
- next

Installing devDependencies:
- typescript
- @types/node
- @types/react
- @types/react-dom
- @tailwindcss/postcss
- tailwindcss
- eslint
- eslint-config-next
- @eslint/eslintrc

added 374 packages, and audited 375 packages in 3m

137 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
Initialized a git repository.

Success! Created gowrish-nextjs-learn01 at C:\Users\myuser\mygit\myapp

========================
CREATE THE APP - OLD
========================
Note:  This will create a folder "app" (or other app name).
If you want git repo to be of the same name, then do not clone git repo first. Instead create the app and then create a git repo based on the created folder.

npx create-next-app@v14.2.21
Need to install the following packages:
create-next-app@14.2.21
Ok to proceed? (y) y

√ What is your project named? ... app
√ Would you like to use TypeScript? ... No / Yes
√ Would you like to use ESLint? ... No / Yes
√ Would you like to use Tailwind CSS? ... No / Yes
√ Would you like to use `src/` directory? ... No / Yes --> default is no, choose yes 
√ Would you like to use App Router? (recommended) ... No / Yes
√ Would you like to customize the default import alias (@/*)? ... No / Yes
Creating a new Next.js app in C:\Users\myuser\mygit\app.

Using npm.

Initializing project with template: app-tw


Installing dependencies:
- react
- react-dom
- next

Installing devDependencies:
- typescript
- @types/node
- @types/react
- @types/react-dom
- postcss
- tailwindcss
- eslint
- eslint-config-next

npm warn deprecated inflight@1.0.6: This module is not supported, and leaks memory. Do not use it. Check out lru-cache if you want a good and tested way to coalesce async requests by a key value, which is much more comprehensive and powerful.
npm warn deprecated @humanwhocodes/config-array@0.13.0: Use @eslint/config-array instead
npm warn deprecated rimraf@3.0.2: Rimraf versions prior to v4 are no longer supported
npm warn deprecated glob@7.2.3: Glob versions prior to v9 are no longer supported
npm warn deprecated @humanwhocodes/object-schema@2.0.3: Use @eslint/object-schema instead
npm warn deprecated eslint@8.57.1: This version is no longer supported. Please see https://eslint.org/version-support for other options.

added 372 packages, and audited 373 packages in 3m

145 packages are looking for funding
  run `npm fund` for details

1 critical severity vulnerability

To address all issues, run:
  npm audit fix --force

Run `npm audit` for details.
Success! Created app at C:\Users\myuser\mygit\app
npm notice
npm notice New major version of npm available! 10.9.2 -> 11.3.0
npm notice Changelog: https://github.com/npm/cli/releases/tag/v11.3.0
npm notice To update run: npm install -g npm@11.3.0
npm notice

========================
Manual installation
========================
NOTE: ONLY if NOT using npx.

To manually create a new Next.js app, install the required packages:

Terminal

npm install next@latest react@latest react-dom@latest
Then, add the following scripts to your package.json file:

package.json

{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  }
}

=============================
"RUN SCRIPTS" IN PACKAGE.JSON
=============================
NOTE: These scripts are called when we run npm run dev etc.

These scripts refer to the different stages of developing an application:
next dev: Starts the development server.
next build: Builds the application for production.
next start: Starts the production server.
next lint: Runs ESLint.

=============================
RUN THE APP
=============================
npm run dev

> app@0.1.0 dev
> next dev

  ▲ Next.js 14.2.21
  - Local:        http://localhost:3000

 ✓ Starting...
Attention: Next.js now collects completely anonymous telemetry regarding usage.
This information is used to shape Next.js' roadmap and prioritize features.
You can learn more, including how to opt-out if you'd not like to participate in this anonymous program, by visiting the following URL:
https://nextjs.org/telemetry

 ✓ Ready in 6.6s

 =======================
 NOTES
 =======================
 The app's folder will have another app folder.
 
 Both layout.tsx and page.tsx will be rendered when the user visits the root of your application (/).
