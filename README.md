# andreaswachs.github.io

This repository supports my [GitHub page](https://andreaswachs.github.io/)


## Todo

- [ ] Write meaningful error messages when loading the JSON file goes bad.
- [ ] Look into making posts on the webpage with Markdown. See detailed [plan #1](#plan1)


## Plans

### <a name="plan1"></a>Plan #1

I want to implement the following:

- Posts are written in a markdown document, one document per post
- Markdown files are stored in a given folder
- Make a script to use some utility to convert them to `html`files.
- Keep a JSON file on hand to tell the application which posts to show
- The app now reads the JSON file and loads the different `html` files into the webpage

**Development so far**
* Markdown parser is implemented
* The markdown parser now parses the body of each post from the JSON file.
* We can now skip the step of converting `.md` files into `.html` files. I can now publish `.md` files and have them parsed.
* Going forward, the JSON file should hold a link to a given `.md` file, which represents one post and the JSON file should hold its date published and...?
