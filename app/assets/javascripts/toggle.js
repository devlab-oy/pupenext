function showHide(elementId) {
    if (document.getElementById) {
        var element = document.getElementById(elementId);
        if (element.style.display == 'none') {
            element.style.display = 'inline';
        } else {
            element.style.display = 'none';
        }
    }
}
