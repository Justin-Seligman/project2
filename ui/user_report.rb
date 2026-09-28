module CustomReports
    def self.generate_user_detail_report(user)
        for post in user.posts  # TODO: ensure attributes are correct
            table_contents += "<tr><td>#{post.id}</td><td>#{post.title}</td><td>#{post.created_date}</td><td>#{post.updated_date.address}</td></tr>"
        end

        html_content = 
        "<!DOCTYPE html>
        <html lang='en'>
        <head>
            <meta charset='UTF-8'>
            <meta name='viewport' content='width=device-width, initial-scale=1.0'>

            <title>User Report</title>

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
                    margin-bottom: 20px;
                }
                
                .metadata td {
                    width: 25%;
                    padding: 15px 15px;
                    border: 2px #ddd solid;
                }

                .meta-cell {
                    background-color: #eee;
                    font-weight: bold;
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
                
                .report tbody tr:nth-child(even) {
                    background-color: #f3f3f3;
                }

                .report th {
                    font-size: 16px;
                    font-weight: bold;
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
                User Detail Report
            </header>

            <table class='metadata'>
                <tr>
                    <td class='meta-cell'>User ID</td>
                    <td>#{user.id}</td>
                    <td class= 'meta-cell'>Admin</td>
                    <td>#{admin}</td>
                </tr>
                <tr>
                	<td class='meta-cell'>Email</td>
				</tr>
				<tr>
                    <td class='meta-cell'>Address</td>
                    <td>Street: #{user.address.street}</td>
                    <td>City: #{user.address.city}</td>
                    <td>State: #{user.address.state}</td>
                </tr>
            </table>

            <table class='report'>
                <thead>
                    <tr>
                        <th>Post ID</th>
                        <th>Title</th>
                        <th>Created Date</th>
                        <th>Updated Date</th>
                    </tr>
                </thead>

                <tbody> 
                    #{table_contents}
                </tbody>
            </table>

            <div class='end'>
                Number of posts: #{user.posts.size}
            </div>

        </body>
        </html>"

        File.write("user-report.html", html_content)
    end
end
