<?php

namespace App\Controllers;

class WebController extends BaseController
{
    public function index(): string
    {
        return view('web_control');
    }

    public function apps(): string
    {
        // Return to the index function
        return redirect()->to('/');
    }

    public function toggleSass()
    {
        $session = session();

        if ($session->has('sassPID')) {
            // Stop the Sass process
            $pid = $session->get('sassPID');
            exec("kill $pid");
            $session->remove('sassPID');
            return $this->response->setJSON(['status' => 'stopped']);
        } else {
            // Start the Sass process
            $command = 'npx sass --watch /var/www/html/public/scss/main.scss /var/www/html/public/css/styles.css > /dev/null 2>&1 & echo $!';
            $pid = shell_exec($command);
            $session->set('sassPID', trim($pid));
            return $this->response->setJSON(['status' => 'started', 'pid' => trim($pid)]);
        }
    }
}
