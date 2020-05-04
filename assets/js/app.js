// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});
liveSocket.connect();

document.addEventListener('phx:update', phxUpdateListener);


function phxUpdateListener(event) {
    renderDrawings();
}



function renderDrawings(){
    var drawings = document.getElementsByClassName("drawing_canvas");

    for (var drawing of drawings){
        renderDrawing(drawing);
    }
}
function renderDrawing(canvas_output) {
        var ctx_output = canvas_output.getContext('2d');
        var dataId = canvas_output.id.replace("canvas_output","data")
        var data = document.getElementById(dataId).value;
        var data_array = new Uint8ClampedArray(data.split(","));
        ctx_output.putImageData(new ImageData(data_array, canvas_output.width, canvas_output.height),0,0);
}

renderDrawings();