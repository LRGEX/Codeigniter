<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<?= base_url('css/styles.css'); ?>">
    <title>Settings</title>
</head>
<body class="dark-mode">
<div class="container">
    <br>
    <div class="row">
        <div class="col">
            <div class="text-center">
                <!-- on click add going to base _url -->
                <img OnClick="location.href='<?= base_url('/'); ?>'" width="250" src="<?= base_url('assets/Dark_Full_Logo.png'); ?>" alt="">
            </div>
            <div class="container col-sm-5">
                <div class="row">
                    <div class="col">
                    </div>
                    <div class="col">
                    </div>
                    <div class="col">
                    <p style="font-family: 'Playball', cursive; font-size: 28px;" class="text-primary">settings</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col">
            <hr class="my-4">
        </div>
    </div>
    <div class="row">
        <div class="col">
        </div>
        <div class="col bg-info rounded">
            <br>
            <form method="post" action="">
                <div class="temp text-center">
                    <p>Press to activate bootstrap watcher</p>
                    <button id="toggleSassButton" type="button" class="btn btn-primary">Start Sass</button>
                    <div id="sassOutput"></div>
                </div>
            </form>
            <br>
        </div>
        <div class="col">
        </div>
    </div>
    <div class="row">
        <div class="col">
            <hr class="my-4">
        </div>
    </div>
</div>
<script src="<?= base_url('js/main.js');?>"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</body>
</html>