function toggleSidebar(){

    let sidebar = document.getElementById("sidebar");

    if(sidebar.style.right === "0px"){
        sidebar.style.right = "-300px";
    }else{
        sidebar.style.right = "0px";
    }

}