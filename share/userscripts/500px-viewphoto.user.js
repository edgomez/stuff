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
    var addViewLink = function (src)
    {
        var viewlink = document.getElementById('viewlink_uscript');
        if (viewlink == null) {
            viewlink = document.createElement('a');
            viewlink.innerHTML = 'Photo Link';
            viewlink.style.cssText = 'font-weight: bold; color: white;';
            viewlink.download = true;
            viewlink.href = src;
            viewlink.id = 'viewlink_uscript';

            var container = document.createElement('div');
            container.style.cssText = 'position: absolute; right: 1ex; top: 10em; z-index: 9999 !important; background: #34bf49; border-radius: 5px; padding: 5px;';
            container.appendChild(viewlink);
            document.body.appendChild(container);

            console.log('500px viewlink: attached link to DOM');
        } else {
            viewlink.setAttribute('href', src);
        }
    }

    var eventHandler = function (events)
    {
        events.forEach(
            function (event) {
                if (event.type == "attributes" && event.attributeName == 'src') {
                    if (event.target.src.indexOf('h%3D300/') == -1 && event.target.alt != "" && event.target.className == "photo-show__img") {
                        console.log('500px viewlink: found matching event');
                        addViewLink(event.target.src);
                    }
                }
            }
        );
    }

    var MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
    var target = document.querySelector('body');
    var observer = new MutationObserver(eventHandler);
    var config = {
        attributes : true,
        //attributeFilter : ["src"],
        //attributeOldValue : false,
        //childList : true,
        subtree : true
    }

    observer.observe(target, config);
    //observer.disconnect();
}
)
();

