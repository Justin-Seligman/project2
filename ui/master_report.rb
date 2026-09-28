require "time"

module Reports
    def generate_master_report(users, admin)
        for user in users  # TODO: ensure user address and other attributes are correct
            table_contents += "<tr><td>#{user.id}</td><td>#{user.name}</td><td>#{user.email}</td><td>#{user.address}</td><td>#{user.posts}</td></tr>"
        end

        date = Time.now()

        html_content = 
        "<!DOCTYPE html>
        <html lang='en'>
        <head>
            <meta charset='UTF-8'>
            <meta name='viewport' content='width=device-width, initial-scale=1.0'>

            <title>Master Report</title>

            <style>
                body {
                    margin: 0;
                    background-color: #ffffff;
                    font-family: Arial, sans-serif;
                }

                .title {
                    width: 100%;
                    padding: 20px 0;
                    background-color: #323232;
                    color: #ffffff;
                    text-align: center;
                    font-size: 24px;
                    font-weight: bold;
                }

                .metadata {
                    width: 100%;
                    border-collapse: collapse;
                    font-size: 16px;
                }

                .metadata td {
                    width: 50%;
                    padding: 15px 15px;
                    border: 2px #ddd solid;
                }

                .report {
                    width: 100%;
                    border-collapse: collapse;
                    font-size: 14px;
                }

                .report th,
                .report td {
                    padding: 12px 15px;
                    text-align: left;
                    border: 1px solid #ddd;
                }

                .report thead {
                    background-color: #ba0c2f;
                    color: #ffffff;
                }

                .report th {
                    font-size: 16px;
                    font-weight: bold;
                }

                .report tbody tr:nth-child(even) {
                    background-color: #f3f3f3;
                }

                .end {
                    width: 100%;
                    box-sizing: border-box;
                    padding-top: 10px;
                    padding-bottom: 10px;
                    background-color: #ffe2e2;
                    border: 2px solid #D0D0D0;
                    text-align: center;
                    font-weight: bold;
                }
            </style>
        </head>

        <body>

            <header class='title'>
                Master Report
            </header>

            <table class='metadata'>
                <tr>
                    <td><strong>Date:</strong> #{date} </td>
                    <td><strong>Admin:</strong> #{admin} </td>
                </tr>
            </table>

            <table class='report'>
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Address</th>
                        <th>Number of Posts</th>
                    </tr>
                </thead>

                <tbody> 
                    #{table_contents} 
                </tbody>
            </table>

            <div class='end'>
                Summary of all registered users
            </div>

        </body>
        </html>"

        File.write("master-report.html", html_content)
    end
end
