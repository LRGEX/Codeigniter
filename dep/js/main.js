


// document.addEventListener('DOMContentLoaded', function() {
//     let sassRunning = false;

//     $('#toggleSassButton').click(function() {
//         const button = $(this);

//         if (sassRunning) {
//             // Stop Sass
//             $.ajax({
//                 url: '/toggle-sass',
//                 type: 'GET',
//                 success: function(response) {
//                     if (response.status === 'stopped') {
//                         $('#sassOutput').html('<pre>Sass process stopped.</pre>');
//                         sassRunning = false;
//                         button.text('Start Sass');
//                     }
//                 },
//                 error: function() {
//                     $('#sassOutput').html('<pre>Error stopping Sass process.</pre>');
//                 }
//             });
//         } else {
//             // Start Sass
//             $.ajax({
//                 url: '/toggle-sass',
//                 type: 'GET',
//                 success: function(response) {
//                     if (response.status === 'started') {
//                         $('#sassOutput').html('<pre>Sass process started.</pre>');
//                         sassRunning = true;
//                         button.text('Stop Sass');
//                     }
//                 },
//                 error: function() {
//                     $('#sassOutput').html('<pre>Error starting Sass process.</pre>');
//                 }
//             });
//         }
//     });
// });

// document.addEventListener('DOMContentLoaded', function() {
//     let sassRunning = false;

//     $('#toggleSassButton').click(function() {
//         const button = $(this);

//         if (sassRunning) {
//             // Stop Sass
//             $.ajax({
//                 url: '/toggle-sass',
//                 type: 'GET',
//                 success: function(response) {
//                     if (response.status === 'stopped') {
//                         $('#sassOutput').html('<pre>Sass process stopped.</pre>');
//                         sassRunning = false;
//                         button.text('Start Sass'); // Update only this part
//                     }
//                 },
//                 error: function() {
//                     $('#sassOutput').html('<pre>Error stopping Sass process.</pre>');
//                 }
//             });
//         } else {
//             // Start Sass
//             $.ajax({
//                 url: '/toggle-sass',
//                 type: 'GET',
//                 success: function(response) {
//                     if (response.status === 'started') {
//                         $('#sassOutput').html('<pre>Sass process started.</pre>');
//                         sassRunning = true;
//                         button.text('Stop Sass'); // Update only this part
//                     }
//                 },
//                 error: function() {
//                     $('#sassOutput').html('<pre>Error starting Sass process.</pre>');
//                 }
//             });
//         }
//     });
// });

document.addEventListener('DOMContentLoaded', function() {
    let sassRunning = localStorage.getItem('sassRunning') === 'true'; // Check the stored state

    updateButtonText(sassRunning);

    $('#toggleSassButton').click(function() {
        const button = $(this);

        if (sassRunning) {
            // Stop Sass
            $.ajax({
                url: '/toggle-sass',
                type: 'GET',
                success: function(response) {
                    if (response.status === 'stopped') {
                        $('#sassOutput').html('<pre>Sass process stopped.</pre>');
                        sassRunning = false;
                        localStorage.setItem('sassRunning', 'false'); // Update the stored state
                        updateButtonText(sassRunning);
                    }
                },
                error: function() {
                    $('#sassOutput').html('<pre>Error stopping Sass process.</pre>');
                }
            });
        } else {
            // Start Sass
            $.ajax({
                url: '/toggle-sass',
                type: 'GET',
                success: function(response) {
                    if (response.status === 'started') {
                        $('#sassOutput').html('<pre>Sass process started.</pre>');
                        sassRunning = true;
                        localStorage.setItem('sassRunning', 'true'); // Update the stored state
                        updateButtonText(sassRunning);
                    }
                },
                error: function() {
                    $('#sassOutput').html('<pre>Error starting Sass process.</pre>');
                }
            });
        }
    });

    function updateButtonText(sassRunning) {
        const button = $('#toggleSassButton');
        if (sassRunning) {
            button.text('Stop Sass');
        } else {
            button.text('Start Sass');
        }
    }
});
