// ==UserScript==
// @name 500px view link
// @version 20181127.01
// @author GomGom
// @description  This script tries to add a view link to view 500px photo in a new tab.
// @include http*://web.500px.com/*
// @include http*://500px.com/*
// @grant GM_addStyle
// ==/UserScript==

(
function ()
{
    var addViewLink = function (img, src)
    {
        var viewlink = document.getElementById('viewlink_uscript');
        if (viewlink == null) {
            var viewlinkdiv = document.createElement('div');
            viewlinkdiv.style.cssText = 'position: absolute; right: 2ex; top: 12em; z-index: 999999; background: #34bf49; border-radius: 5px; padding: 5px; visibility: visible;';

            viewlink = document.createElement('a');
            viewlink.innerHTML = '&#8651; View fullscreen';
            viewlink.style.cssText = 'font-weight: bold; color: white; visibility: visible; ';
            viewlink.download = true;
            viewlink.href = src;
            viewlink.target = '_blank';
            viewlink.id = 'viewlink_uscript';

            // Depending on the matching URL, this may be either
            // 1. right click preventer div or,
            // 2. the base react photoviewer
            // Both are good base containers for our viewlink anyway as it has the following properties:
            // 1. It'll exist
            // 2. It'll disappear somehow if the user isn't looking at a single photo
            var photoviewer = img.parentNode.parentNode;
            photoviewer.appendChild(viewlinkdiv);
            viewlinkdiv.appendChild(viewlink);

            console.log('500px viewlink: attached link to DOM');
        } else {
            console.log('500px viewlink: updated link');
            viewlink.setAttribute('href', src);
        }
    }

    var eventHandler = function (events)
    {
        events.forEach(
            function (event) {
                if (   event.type == "attributes"
                    && event.attributeName == 'src') {
                    if (   event.target.src.indexOf('h%3D300/') == -1
                        && event.target.alt != ""
                        && event.target.className == "photo-show__img") {
                        console.log('500px viewlink: found matching event');
                        addViewLink(event.target, event.target.src);
                    }
                }
            }
        );
    }

    var MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
    var target = document.querySelector('body');
    var observer = new MutationObserver(eventHandler);
    var config = {attributes : true, subtree : true }

    observer.observe(target, config);
}
)
();

