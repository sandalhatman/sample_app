function limitText(limitField, limitNum) {
    alert ("HELLO WORLD");
    if (limitField.value.length > limitNum) {
    limitField.value = limitField.value.substring(0, limitNum);
    }
}