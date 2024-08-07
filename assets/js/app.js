// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import hljs from "highlight.js"
import { resizeImage } from "./image_resizer"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

function updateLineNumbers(val, element_id="#line-numbers") {
  // console.log(`In updateLineNumbers: ${element_id}`)
  const lineNumberText = document.querySelector(element_id)
  
  // console.log(lineNumberText)
  if (!lineNumberText) return

  const lines = val.split("\n")
  const numbers = lines.map((_, index) => index + 1).join("\n") + "\n"

  return lineNumberText.value = numbers
}

let Hooks = {}

Hooks.Highlight = {
  mounted() {
    // console.log("\n\nMOUNTED HIGHLIGHT")
    const listNum = (this.el.id).split("-")[1]
    // console.log(listNum)

    let name = this.el.getAttribute("data-name")

    // 'pre code' HTML tags are in gist_live.html.heex
    let codeBlock = this.el.querySelector("pre code")

    if (codeBlock && name) {
      codeBlock.className = codeBlock.className.replace("/language-\S+/g", "")
      let extension = name.split(".").pop()
      // console.log(hljs.getLanguage(extension))
      // console.log(hljs.getLanguage(extension).name)
      langName = hljs.getLanguage(extension).name
      if (langName === "HTML, XML") {
        langName = "HTML"
      }
      codeBlock.classList.add(langName)
      trimmed = this.trimCodeBlock(codeBlock)
      hljs.highlightElement(trimmed)

      if (listNum === undefined) {
        updateLineNumbers(trimmed.textContent, "#syntax-numbers")
      } else {
        updateLineNumbers(trimmed.textContent, `#syntax-numbers-${listNum}`)
      }
    }
  },

  updated() {
    // console.log("\n\nUPDATED HILI")
    const listNum = (this.el.id).split("-")[1]
    let name = this.el.getAttribute("data-name")

    // 'pre code' HTML tags are in gist_live.html.heex
    let codeBlock = this.el.querySelector("pre code")

    if (codeBlock && name) {
      codeBlock.className = codeBlock.className.replace("/language-\S+/g", "")
      let extension = name.split(".").pop()
      // console.log(hljs.getLanguage(extension))
      // console.log(hljs.getLanguage(extension).name)
      langName = hljs.getLanguage(extension).name
      if (langName === "HTML, XML") {
        langName = "HTML"
      }
      codeBlock.classList.add(langName)
      trimmed = this.trimCodeBlock(codeBlock)
      hljs.highlightElement(trimmed)

      if (listNum === undefined) {
        updateLineNumbers(trimmed.textContent, "#syntax-numbers")
      } else {
        updateLineNumbers(trimmed.textContent, `#syntax-numbers-${listNum}`)
      }
    }
  },

  trimCodeBlock(codeBlock) {
    const lines = codeBlock.textContent.split("\n")
    if (lines.length > 2) {
      lines.shift()
      lines.pop()
    }
    codeBlock.textContent = lines.join("\n").replace(/\n+$/, "")

    return codeBlock
  }
}

Hooks.UpdateLineNumbers = {
  mounted() {
    // console.log("UpdateLineNumber hook")
    const lineNumberText = document.querySelector("#line-numbers")

    this.el.addEventListener("input", () => {
      updateLineNumbers(this.el.value)
    })

    this.el.addEventListener("scroll", () => {
      lineNumberText.scrollTop = this.el.scrollTop
    })

    this.el.addEventListener("keydown", (e) => {
      if (e.key == "Tab") {
        e.preventDefault();
        var start = this.el.selectionStart
        var end = this.el.selectionEnd
        this.el.value = this.el.value.substring(0, start) + "\t" + this.el.value.substring(end)
        this.el.selectionStart = this.el.selectionEnd = start + 1
      }
    })

    this.handleEvent("clear-textareas", () => {
      this.el.value = ""
      lineNumberText.value = "1\n"
    })

    updateLineNumbers(this.el.value)
  }
};

Hooks.CopyToClipboard = {
  mounted() {
    console.log("Copy")
    console.log(this.el)
    this.el.addEventListener("click", ev => {
      const textToCopy = this.el.getAttribute("data-clipboard-gist")
      if (textToCopy) {
        navigator.clipboard.writeText(textToCopy).then(() => {
          console.log("Gist copied to clipboard")
        }).catch(error => {
          console.log("Failed to copy text with error: ", error)
        })
      }
    })
  }
}

Hooks.ToggleEdit = {
  mounted() {
    this.el.addEventListener("click", () => {
      let edit = document.getElementById("edit-section")
      let syntax = document.getElementById("syntax-section")
      if (edit && syntax) {
        edit.style.display = "block"
        syntax.style.display = "none"
      }
    })
  }
}


Hooks.Resize = {
  mounted() {
    const maxWidth = 250
    const maxHeight = 250

    let imageInput = document.getElementById("profile-image-uploader")

    // Inspired by blog-post https://imagekit.io/blog/how-to-resize-image-in-javascript/
    imageInput.addEventListener('change', function (e) {
      if (e.target.files) {
        let imageFile = e.target.files[0];

        var reader = new FileReader();
        reader.onload = function (e) {
          const image = new Image()
          image.onload = () => {
            const dataUrl = resizeImage(image, maxWidth, maxHeight)

            if (dataUrl.length === 0) {
              return;
            }

            let resizedImage = document.getElementById("image-preview") ?? new Image()
            resizedImage.setAttribute("id", "image-preview")
            resizedImage.setAttribute("alt", "Preview")
            resizedImage.src = dataUrl

            document.getElementById("image-preview-container").appendChild(resizedImage)

            hiddenInput = document.getElementById("profile-image-src-input")
            hiddenInput.value = dataUrl
            hiddenInput.dispatchEvent(
              new Event("input", {bubbles: true})
            )
          }

          image.src = e.target.result
        }

        reader.readAsDataURL(imageFile);
      }
    })
  }
}

let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

