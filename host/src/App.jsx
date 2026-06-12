import React, { Suspense } from "react";

const UpsellWidget = React.lazy(() => import("upsellRemote/UpsellWidget"));

export default function App() {
  return (
    <div style={{ maxWidth: "1200px", margin: "0 auto", padding: "40px 16px" }}>
      <h1 style={{ fontSize: "2rem", marginBottom: "8px" }}>Host Application</h1>
      <p style={{ color: "#666", marginBottom: "32px" }}>
        This is the shell app. The widget below is loaded from the remote MFE.
      </p>
      <Suspense fallback={<p>Loading remote widget...</p>}>
        <UpsellWidget userId="demo-user-42" />
      </Suspense>
    </div>
  );
}
