// ==UserScript==
// @name 500px Original image
// @version 20220416.01
// @author GomGom
// @description  This script tries to find the original URL of the image
// @match http*://web.500px.com/*
// @match http*://500px.com/*
// @grant GM_addStyle
// ==/UserScript==

(
function ()
{
    // @brief Retrieve a 500px image information starting from one of its URLs,
    //        and executes the onload(image_id, image_information_response) call
    //        when the information is ready
    // @param fivehundred_url The 500px URL matching scheme://.*/photo/[:digit:]+/name
    // @param onload Callback to call when the information is ready
    var get_image_info = function(fivehundred_url, onload)
    {
        // let id = window.location.href.match('.*/photo/\([^/]+\)/');
        let id = fivehundred_url.match('.*/photo/\([^/]+\)/');
        if (id == null || id.length <= 1)
        {
            return;
        }

        console.log("500px origlink: looking details about photo " + id[1]);
        let xhr = new XMLHttpRequest();
        xhr.onload = function(progressEvent)
        {
            onload(id[1], xhr.responseText);
        };
        xhr.open('GET', 'https://api.500px.com/v1/photos?ids=' + id[1] + '&image_size[]=1&image_size[]=2&image_size[]=32&image_size[]=31&image_size[]=33&image_size[]=34&image_size[]=35&image_size[]=36&image_size[]=2048&image_size[]=4&image_size[]=14&include_states=1&expanded_user_info=true&include_tags=true&include_geo=true&is_following=true&include_equipment_info=true&include_licensing=true&include_releases=true&liked_by=1&include_vendor_photos=true', true);
        xhr.send();
    }

    // @brief Prepare a div element that includes a link element for that URL
    // @return The div element
    var create_origlink_div = function(url)
    {
        var origlinkdiv = document.createElement('div');
        origlinkdiv.style.cssText = 'position: absolute; right: 2ex; top: 15em; z-index: 999999; background: orange; border-radius: 5px; padding: 5px; visibility: visible;';

        var origlink = document.createElement('a');
        origlink.innerHTML = '&#8651; View Original';
        origlink.style.cssText = 'font-weight: bold; color: white; visibility: visible; ';
        origlink.download = true;
        origlink.href = url;
        origlink.target = '_blank';
        origlink.id = 'origlink_uscript';

        origlinkdiv.appendChild(origlink);

        return origlinkdiv;
    }

    // @brief Update the orig link found in the page
    // @param anchorEl Anchor element that triggered the update. Its parentNode.parentNode is assumed to be the 500px photoviewer
    // @param url The corresponding 500px image URL
    var updateOrigLink = function (anchorEl, url)
    {
        // Look for the origlink link element
        var origlinkEl = document.getElementById('origlink_uscript');

        // The action will depend on the link prior existence
        var actionOnOrigLinkEl;
        if (origlinkEl == null)
        {
            // A new link element needs to be inserted in the DOM
            actionOnOrigLinkEl = function(orig_url)
            {
                var photoviewer = anchorEl.parentNode.parentNode;
                var origlinkdiv = create_origlink_div(orig_url);
                photoviewer.appendChild(origlinkdiv);
                console.log('500px origlink: attached new link to DOM');

            };
        }
        else
        {
            actionOnOrigLinkEl = function(orig_url)
            {
                origlinkEl.setAttribute('href', orig_url);
                console.log('500px origlink: updated link');
            };
        }

        // The following callback will be called when the image information is found
        var imginfo_onload = function(id, responseText)
        {
            const res = JSON.parse(responseText);
            res.photos[id].images.forEach( image => {
                if (image.size == 2048)
                {
                    // the image with 2048 size is the maximum size 500px has to offer
                    actionOnOrigLinkEl(image.https_url);
                }
            });
        }

        // Asynchronously request the image information, that will trigger the
        // necessary actions to be taken
        get_image_info(url, imginfo_onload);
    }

    // @brief Event handler that will trigger a link update whenever a photo-show__img element is updated
    var eventHandler = function (events)
    {
        events.forEach(
            function (event) {
                if (event.type == "attributes" &&
                    event.attributeName == 'src')
                {
                    if (event.target.src.indexOf('h%3D300/') == -1 &&
                        event.target.alt != "" &&
                        event.target.className == "photo-show__img")
                    {
                        console.log('500px origlink: found matching event');
                        updateOrigLink(event.target, event.target.src);
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
